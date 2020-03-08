FROM jupyter/scipy-notebook:latest

# Install .NET CLI dependencies

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    # Install .NET CLI dependencies
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu60 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    # For ImportExcel autosize
    libgdiplus libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 3.1.101

RUN curl -SL --output dotnet.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='eeee75323be762c329176d5856ec2ecfd16f06607965614df006730ed648a5b5d12ac7fd1942fe37cfc97e3013e796ef278e7c7bc4f32b8680585c4884a8a6a1' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # Opt out of telemetry until after we install jupyter when building the image, this prevents caching of machine id
    DOTNET_TRY_CLI_TELEMETRY_OPTOUT=true

# Trigger first run experience by running arbitrary cmd
RUN dotnet help

# Copy notebooks, package sources, and source code
# NOTE: Do this before installing dotnet-try so we get the
# latest dotnet-try everytime we change sources.
COPY ./NotebookExamples/ ${HOME}/Notebooks/
COPY ./NuGet.config ${HOME}/nuget.config
COPY ./src/ ${HOME}/src/

RUN mkdir ${HOME}/packages/ ${HOME}/localNuget/

RUN chown -R ${NB_UID} ${HOME}
USER ${USER}

# Install Microsoft.DotNet.Interactive
RUN dotnet tool install -g Microsoft.dotnet-interactive --add-source "https://dotnet.myget.org/F/dotnet-try/api/v3/index.json"

ENV PATH="${PATH}:${HOME}/.dotnet/tools"
RUN echo "$PATH"

# Install kernel specs
RUN dotnet interactive jupyter install

# Build extensions
RUN dotnet build ${HOME}/src/Microsoft.ML.DotNet.Interactive.Extensions -c Release
RUN dotnet pack ${HOME}/src/Microsoft.ML.DotNet.Interactive.Extensions -c Release

RUN dotnet build ${HOME}/src/Microsoft.Data.Analysis.Interactive -c Release
RUN dotnet pack ${HOME}/src/Microsoft.Data.Analysis.Interactive -c Release

# Publish nuget if there is any
WORKDIR ${HOME}/src/
RUN dotnet nuget push **/*.nupkg -s ${HOME}/localNuget/

RUN rm -fr ${HOME}/src/

# install powershell modules
RUN dotnet tool install --global PowerShell
RUN pwsh -c "install-module pskit -force"
RUN pwsh -c "install-module nameit -force"
RUN pwsh -c "install-module psstringscanner -force"
RUN pwsh -c "install-module importexcel -force"

# Enable telemetry once we install jupyter for the image
ENV DOTNET_TRY_CLI_TELEMETRY_OPTOUT=false

# Set root to Notebooks
WORKDIR ${HOME}/Notebooks/
