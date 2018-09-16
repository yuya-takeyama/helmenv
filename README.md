# helmenv

[Helm](https://helm.sh) version manager.

Most of the codes are taken from below tools:

* [rbenv](https://github.com/rbenv/rbenv)
* [tfenv](https://github.com/Zordrak/tfenv)

## Installation

1. Check out helmenv into any path (here is `${HOME}/.helmenv`)

  ```sh
  $ git clone https://github.com/yuya-takeyama/helmenv.git ~/.helmenv
  ```

2. Add `~/.helmenv/bin` to your `$PATH` any way you like

  ```sh
  $ echo 'export PATH="$HOME/.helmenv/bin:$PATH"' >> ~/.bash_profile
  ```

## Usage

```
Usage: helmenv <command> [<args>]

Some useful helmenv commands are:
   local       Set or show the local application-specific Helm version
   global      Set or show the global Helm version
   install     Install the specified version of Helm
   uninstall   Uninstall the specified version of Helm
   version     Show the current Helm version and its origin
   versions    List all Helm versions available to helmenv

See `helmenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/yuya-takeyama/helmenv#readme
```

## License

* helmenv
  * The MIT License
* [rbenv](https://github.com/rbenv/rbenv)
  * The MIT License
* [tfenv](https://github.com/Zordrak/tfenv)
  * The MIT License
