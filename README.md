crashdesk-ruby [![Build Status](https://secure.travis-ci.org/crashdesk/crashdesk-ruby.png?branch=master)](http://travis-ci.org/crashdesk/crashdesk-ruby)
==============

Crashde.sk Ruby client library for [Crashde.sk](http://crashde.sk) service

How to Install
--------------

1. Install gem 
  
    a) Add the `crashdesk` gem to your `Gemfile`

      ```ruby
      gem "crashdesk"
      ```

      ```shell
      bundle install
      ```

    b) Install `crashdesk` gem to your system

      ```shell
      gem install crashdesk
      ```

3.  Copy the configuration to your Ruby project

    ```ruby
    Crashdesk.configure do |config|
      config.app_key = "YOUR_API_KEY"
    end
    ```

Configuration
-------------

To configure additional settings, use the block syntax and set any
settings you need on the `config` block variables. For example:

```ruby
Crashdesk.configure do |config|
  config.app_key = "YOUR_API_KEY"
  config.use_ssl = true
end
```

###app_key

Your Bugsnag APP key (required).

```ruby
config.app_key = "YOUR_API_KEY"
```

###use_ssl

Enforces all communication with servers be made via SSL.

```ruby
config.use_ssl = true
```

By default, `use_ssl` is set to false.

Format of Crashlog:
-------------------

- Hash ID
  MD5 hash of backtrace giving the exception uniq hash.

- CRC hash
  This has is going to be used for displaying for user. It's sort to be read out loud.

- Occured at timestamp
  Exact time of exception/error occurence. Format is ISO-8601.

- Environment
  Whatever you feel is important to capture from application's environment.
  ---
    Eq:
      - Language name [ruby]
      - Language version [1.9.3]
      - Language platform [i486-linux]

- Context
  Capturing context of the data surrounding exception in time of raise/throw.
  ---
    Eq:
      - Framework [rails || sinatra || rack]
      - Framework version string [3.2.x]

- Exception
  Data describing exception.
  ---
    Eq:
      - Exception class [StandardError]
      - Exception message [Whatever you pass in the exception]
      - Backtrace

TODO
----
Add Gemnasium to track dependencies: https://gemnasium.com
Add Travis CI to run test

Reporting bug or Feature request
--------------------------------

Please report any bugs or feature requests on the github issues page for this
project:

<https://github.com/crashdesk/crashdesk-ruby/issues>


Contributing
------------

-   Fork the repo
-   Commit and push
-   [Make a pull request](https://help.github.com/articles/using-pull-requests)
-   Thank you!


License
-------

The Crashdeks Ruby client is free software released under the MIT License. 
See [LICENSE.txt](https://github.com/crashdesk/crashdesk-ruby/blob/master/MIT_LICENSE) for details.

