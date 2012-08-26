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
      config.api_key = "YOUR_API_KEY_HERE"
    end
    ```

Configuration
-------------

To configure additional settings, use the block syntax and set any
settings you need on the `config` block variables. For example:

```ruby
Crashdesk.configure do |config|
  config.api_key = "YOUR_API_KEY_HERE"
  config.use_ssl = true
end
```

###api_key

Your Bugsnag API key (required).

```ruby
config.api_key = "YOUR_API_KEY_HERE"
```

###use_ssl

Enforces all communication with servers be made via SSL.

```ruby
config.use_ssl = true
```

By default, `use_ssl` is set to false.

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

