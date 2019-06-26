# Rails Kickoff – Tailwind
A rapid Rails (5.2.3) application template for personal use. This particular template utilizes [Tailwind CSS](https://tailwindcss.com/), a utility-first CSS framework for rapid UI development.

Tailwind depends on Webpack so this also comes bundled with [webpacker](https://github.com/rails/webpacker) support.

Inspired heavily by [Jumpstart](https://github.com/excid3/jumpstart) from [Chris Oliver](https://twitter.com/excid3/). Credits to him for a bunch here.

Be sure to also check out [Jumpstart Pro](https://jumpstartrails.com) to save loads of time creating your next Rails application. Chris, Jason, and I teamed up on it.

### Included gems

- [devise](https://github.com/plataformatec/devise)
- [friendly_id](https://github.com/norman/friendly_id)
- [sidekiq](https://github.com/mperham/sidekiq)
- [webpacker](https://github.com/rails/webpacker)

### Tailwind CSS by default
Using PostCSS we can install Tailwind as a base CSS framework to harness. I prefer Tailwind due to it's un-opinionated approach.

## How it works

When creating a new rails app simply pass the template file through.

### Creating a new app

```bash
$ rails new sample_app -d <postgresql, mysql, sqlite> -m template.rb
```

### Once installed what do I get?

- Webpack support + Tailwind CSS configured in the `app/javascript` directory.
- Devise with a new `username` and `name` field already migrated in. Enhanced views using Tailwind CSS.
- Support for Friendly IDs thanks to the handy [friendly_id](https://github.com/norman/friendly_id) gem. Note that you'll still need to do some work inside your models for this to work. This template installs the gem and runs the associated generator.
- Optional Foreman support thanks to a `Profile`. Once you scaffold the template, run `foreman start` to initalize and head to `locahost:5000` to get `rails server`, `sidekiq` and `webpack-dev-server` running all in one terminal instance. Note: Webpack will still compile down with just `rails server` if you don't want to use Foreman. Foreman needs to be installed as a global gem on your system for this to work. i.e. `gem install foreman`
- A custom scaffold view template when generating theme resources (Work in progress).
- Git initialization out of the box

#### Booting your local server with redis

To utilize foreman with Sidekiq noted above you'll need to install redis. The gem comes within a new rails application but it is commented out. Uncomment that line and run `bundle install`. It also might be handy to install redis on your machine (assuming you're on a mac) run `brew install redis` to install it. Then in a new terminal instance you can run `redis-server`.

After that is running, open a new terminal instance and finally run `foreman start`. Head to `locahost:5000` to see your app. You'll have hot reloading on `js` and `css` and `scss/sass` files by default. Feel free to configure to look for more to compile reload as your app scales.


### Watch an overview

 📹 [https://youtu.be/kuKMRl8nj2w](https://youtu.be/kuKMRl8nj2w) - A bit dated now that Rails 6.0.0.rc1 is out now.
