FROM openjdk:17-bullseye

LABEL duccuideptrai <himyfriend.webhost@gmail.com>

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
ENV ANDROID_API_LEVEL android-33
ENV ANDROID_BUILD_TOOLS_VERSION 33.0.2
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_VERSION 33
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/bin

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $ANDROID_SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
# Download Android SDK
yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME && \
sdkmanager --update --sdk_root=$ANDROID_HOME && \
sdkmanager --sdk_root=$ANDROID_HOME "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" \
    "extras;android;m2repository" \
    "extras;google;m2repository" && \
# Install Fastlane
apt-get update && \
apt-get install --no-install-recommends -y --allow-unauthenticated build-essential git ruby-full && \
gem install rake && \
gem install fastlane && \
gem install bundler && \
# Install ktlint
curl -sSLO https://github.com/pinterest/ktlint/releases/download/0.50.0/ktlint && \
chmod a+x ktlint && \
mv ktlint /usr/local/bin/ && \
# Install reviewdog
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s && \
mv ./bin/reviewdog /usr/local/bin/reviewdog && \
# Install detekt
curl -sSLO https://github.com/detekt/detekt/releases/download/v1.23.0/detekt-cli-1.23.0.zip && \
unzip detekt-cli-1.23.0.zip && \
rm detekt-cli-1.23.0.zip && \
mv ./detekt-cli-1.23.0 /usr/local/bin/detekt && \
ln -s /usr/local/bin/detekt/bin/detekt-cli /usr/local/bin/detekt-cli && \
# Clean up
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
apt-get autoremove -y && \
apt-get clean

