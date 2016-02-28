## contacts.vim

OSX Contacts.app omni-completion for 'mail' filetype files.

You might find this plugin useful if you're using `mutt` because it enables
email address completion.

Only works for OSX Contacts.app.

### Installation

- Install [contacts](https://github.com/tgray/contacts) CLI app with:

        brew install https://raw.github.com/tgray/homebrew-tgbrew/master/contacts2.rb

  This is a hard dependency!
  Installing the other `contacts` app via `brew install contacts` won't work.

- Install this vim plugin using your prefered plugin manager.

### Usage

It is assumed you're using `mutt` as your email client.

- create a new email in `mutt` with vim
- `<C-X><C-O>` omnicomplete your contacts email addresses

### License

[MIT](LICENSE.md)
