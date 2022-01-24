[Connect with GitHub using SSH](https://rakeshjain-devops.medium.com/connect-with-github-using-ssh-bb1aeb48e869)

You can connect to GitHub using the Secure Shell Protocol (SSH), which provides a secure channel over an unsecured network.
This is a step by step guide to configure ssh connection with your GitHub account.


[Let's Move our GitHub to Terminal. Yes!! gh-CLI is available!!](https://dev.to/rahulmanojt/let-s-move-our-github-to-terminal-yes-gh-cli-is-available-587o#github-cli)

`gh` is GitHub on the command line. It brings pull requests, issues, and other GitHub concepts to the terminal next to where you are already working with git and your code.

`brew install gh`
- Run `gh auth login` to authenticate with your GitHub account

-	Create a repo `gh repo create my-project`

[Is it possible to clone only part of a git project?](https://unix.stackexchange.com/questions/233327/is-it-possible-to-clone-only-part-of-a-git-project)

You will end up downloading the entire history, so I don't see much benefit in it, but you can checkout specific parts using a "sparse" checkout.

[How to Setup Branch Protection Rules](https://cycode.com/blog/how-to-setup-branch-protection-rules-2/)

Branching is the cornerstone of cooperative work using Git. Developers utilize branches to work on the same source code repository in parallel. Generally speaking, when working with branches, there is one main branch in a repository from which various developers create their own additional, diverging branches. Once a developer’s project is done, they then merge their side branch back into the main branch.