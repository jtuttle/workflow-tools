# workflow-cli
A CLI for managing story workflow via Github.

## Installation

1. Clone the repo:

    ```bash
    git clone git@github.com:jtuttle/workflow-cli.git
    ```

2. Install dependencies

Since `workflow-cli` is implemented in Ruby, you will first need to [install RVM](https://rvm.io/rvm/install). Then install Ruby with `rvm install ruby-2.4.1`

3. Obtain Github access token

4. Copy `config/config.yml.sample` to `config/config.yml` and insert your Github Access token:

    ```bash
    cd $WORK/workflow-cli/config
    cp config.yml.sample config.yml
    ```

5. Add the `/bin` directory and tab-completion script to your `$PATH`:

    ```bash
    echo "export PATH=\$PATH:<your>/<path>/<to>/workflow-cli/bin" >> ~/.profile
    echo "source ~/<my>/<path>/<to>/workflow-cli/tabcomplete.sh" >> ~/.profile
    ```

## Project Configuration

## Sample Workflow