
# configureplus

Configureplus is a minimal autoconf-like configure tool that depends only on bash. It simplifies the process of managing project configurations across different platforms and environments.

## Features

- Cross-platform configuration management
- Session-based configurations
- Variable management with documentation support
- Multiple output formats (Makefile, Bash, JSON)
- Minimal dependencies (requires only bash)
- Automated configuration file generation
- Flexible and extensible

## Installation

### macOS (darwin19)

```bash
$ make
$ cd build
$ make
$ cd platform/darwin19
$ make install  # for user profile installation
# OR
$ make install-systemwide  # for system-wide installation
```

### Linux (linux-gnu)

```bash
$ make
$ cd build
$ make
$ cd platform/linux-gnu
$ make install  # for user profile installation
# OR
$ make install-systemwide  # for system-wide installation
```

## Usage

Basic usage:

```bash
$ configureplus <command> [args]
```

Available commands:

- `man`: Show the manual page (in markdown format)
- `help <command>`: Get help for a specific command
- `env`: Show environment variables
- `set <varname> <value>`: Set a variable (for the current session or globally)
- `get <varname>`: Get a variable value
- `status`: Show local/global configuration tree
- `list`: List local/global session paths

## Examples

```bash
# Set a variable
$ configureplus set ALPHA 123

# Get a variable
$ configureplus get ALPHA
123

# Create a local session (ostype) SESSION var
$ configureplus get SESSION

# Fetch (create if not exists) a local session 'local1', SESSION var 
$ CONFIGUREPLUS_SESSION=local1 configureplus get SESSION

# Update global session (ostype)
$ configureplus --global
```

## Variable Lookup Order

The `get` function in configureplus searches for variables in a specific order across local, session, and global directories. This allows for flexible configuration management with clear precedence rules.

### Search Order

When you use `configureplus get <varname>`, the tool searches for the variable in the following order:

1. **Local Session**: `$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/<varname>`
   - This is specific to the current working directory and session.

2. **Global Session**: `$CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/<varname>`
   - This is specific to the current session but applies across all directories.

3. **Global Default**: `$CONFIGUREPLUS_DIR_CONFIG/$CONFIGUREPLUS_DIR_OUT/global/<varname>`
   - This is the fallback for all sessions and directories.

### Example

Let's say you're looking for the variable `ALPHA`:

```bash
$ configureplus get ALPHA
```

The tool will search in this order:

1. `./.configureplus/session/current_session/ALPHA`
2. `~/.config/configureplus/.configureplus/session/current_session/ALPHA`
3. `~/.config/configureplus/.configureplus/global/ALPHA`

It will return the value from the first location where the variable is found. If the variable is not found in any of these locations, it will return an empty result.

### Using the `global` Flag

If you use the `global` flag:

```bash
$ configureplus get ALPHA global
```

The tool will skip the local session search and only look in the global session and global default locations.

### Listing Available Sessions

You can use the `list` command to see all available sessions:

```bash
$ configureplus list
```

This will show you:
- Global sessions in `~/.config/configureplus/.configureplus/session/`
- Local sessions in the current directory's `.configureplus/session/` (if it exists)

Understanding this search order helps you manage your configurations effectively across different scopes and sessions.

## Configuration Files

Configureplus generates several configuration files:

- `.configureplus/global.mk`: Global Makefile include
- `.configureplus/global.bash`: Global Bash script (with exports)
- `.configureplus/global.bash_local`: Global Bash script (without exports)
- `.configureplus/global.json`: Global JSON configuration
- `.configureplus/session/<session-id>.mk`: Session-specific Makefile include
- `.configureplus/session/<session-id>.bash`: Session-specific Bash script (with exports)
- `.configureplus/session/<session-id>.bash_local`: Session-specific Bash script (without exports)
- `.configureplus/session/<session-id>.json`: Session-specific JSON configuration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[Add your chosen license here]

## Author

Murat Uenalan <murat.uenalan@gmail.com>


    

