# workflow-tools
A configurable CLI for managing project workflow.

## Installation

1. Clone the repo:

    ```bash
    git clone git@github.com:jtuttle/workflow-tools.git
    cd workflow-tools
    ```

1. Install dependencies. Since `workflow-tools` is implemented in Ruby, you will first need to [install RVM](https://rvm.io/rvm/install). Then:

    ```bash
    rvm install ruby-2.4.1
    gem install bundler
    bundle install
    ```

1. Copy `config/config.yml.sample` to `config/config.yml` and insert the credentials for your desired services (see [the wiki](https://github.com/jtuttle/workflow-tools/wiki) for details).

    ```bash
    cp config/config.yml.sample config/config.yml
    ```

1. Add the `/bin` directory to your `$PATH`:

    ```bash
    echo "export PATH=\$PATH:<your>/<path>/<to>/workflow-tools/bin" >> ~/.profile
    ```

## Project Configuration

## Sample Workflow
