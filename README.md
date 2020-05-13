# Deadlyzer
Deadlyzer lets you to compare directories and reveal unreferenced, uncalled constats to remove

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deadlyzer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install deadlyzer

## Usage

To use deadlyzer you should create deadlyzer.yml file with following content

```yaml
target: 
  path: './app/workers'
  exclude_consts:
    - 'Sidekiq::Worker' 
against:   
  path: './app/controllers'
```

Available options

* exclude_const (Array)
* exclude_dirs  (Array)

```sh
user@desktop: ~$ deadlyzer # to run
```

## Development

Working principle is simple enough. Gem uses Rubocup and Parser gems to creat Abstract Syntax Tree. Using '(const ...)' pattern to match with nodes on the tree

## Contributing
Deadlyzer is still under development and created to use personal purpose where problems can solve with finding uncalled constants. If you also need it or would like to contribute it would be great :)