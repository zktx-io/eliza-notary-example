# Eliza Notary Example

## Overview

**Eliza Notary** is an AI-driven solution that automatically audits smart contract code and identifies security vulnerabilities, while transparently verifying consistency between deployed code and open-source repositories using the **SLSA framework**.

### Example Workflow File

Below is an example of how to include the Secure Audit Master action in your workflow file:

```yml
name: Comment Triggered Workflow

on:
  issue_comment:
    types: [created]

jobs:
  run-on-comment:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      pull-requests: write
      contents: read

    steps:
      - name: Determine branch
        id: determine_branch
        run: |
          if [[ -n "${{ github.event.issue.pull_request }}" ]]; then
            echo "Running on PR..."
            PR_NUMBER=${{ github.event.issue.number }}
            echo "BRANCH=refs/pull/${PR_NUMBER}/head" >> $GITHUB_ENV
          else
            echo "Running on issue..."
            echo "BRANCH=main" >> $GITHUB_ENV
          fi

      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          ref: ${{ env.BRANCH }}

      - name: Run Eliza Notary
        uses: zktx-io/eliza-notary@main
        with:
          project-path: './my_project'
          character-path: './my_character.json'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          DEEPSEEK_API_KEY: ${{ secrets.DEEPSEEK_API_KEY }}
```

## Issue Comment Commands

The Secure Audit Master action is designed to be triggered by comments on issues. Depending on the command provided, the action will automatically execute one of the following functions:

### Help Command: **/eliza help**

- Usage:
  - Post the comment /eliza help on an issue.
- Functionality:
  - The action will automatically reply with a help message that outlines all available commands, including their descriptions and usage instructions.
- Example Output:

```bash
Usage: /eliza [command] [options]

Commands:
  /eliza help
    Display available commands and their descriptions.

  /eliza audit model=[openai|deepseek]
    Perform an audit of the repository's code.
    The 'model' option must be either 'openai' or 'deepseek'.

  /eliza summary model=[openai|deepseek]
    Summarize the issue content using AI.
    The 'model' option allows you to choose an AI model for summarization.
```

### Code Audit Command: **/eliza audit model=[openai|deepseek]**

- Usage:
  - Post a comment such as /eliza audit model=openai or /eliza audit model=deepseek on an issue.
- Functionality:
  - Invokes the specified AI model to collect the project’s source code (e.g., smart contract code) and test result file (test_results.txt).
  - Performs a code audit and posts the resulting report as a comment, including the prompts and source references used during the audit process.
- Expected Outcome:
  - Identifies security vulnerabilities and areas for improvement in the code before smart contract deployment.
  - Automatically generates an audit report during a Pull Request, enabling team members to quickly understand the changes and potential risks.

### Issue Summary Command: **/eliza summary model=[openai|deepseek]**

- Usage:
  - Post a comment such as /eliza summary model=openai or /eliza summary model=deepseek on an issue.
- Functionality:
  - Aggregates all comments within the issue and leverages AI to generate a concise, coherent summary.
  - Posts the summary as a comment, complete with the prompts and reference materials used in the summarization process.
- Expected Outcome:
  - Provides a quick overview of extensive issue discussions, greatly enhancing collaborative efficiency.
  - Helps team members rapidly identify the core discussion points, thereby facilitating faster decision-making and problem resolution.

## Github

- Get started with **SLSA on Sui** and learn by [github](https://github.com/zktx-io/slsa-on-sui)
- Get started with **Eliza Notary** and learn by [github](https://github.com/zktx-io/eliza-notary)
