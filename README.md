# Rails Kickoff – Tailwind
A rapid template Rails (5.2 +) application template for personal use. This particular template utilizes [Tailwind CSS](https://tailwindcss.com/), a utility-first CSS framework for rapid UI development.

Tailwind depends on Webpack so this also comes bundled with [webpacker](https://github.com/rails/webpacker) support.

### Included gems

- [devise](https://github.com/plataformatec/devise)
- [friendly_id](https://github.com/norman/friendly_id)
- [foreman](https://github.com/ddollar/foreman)
- [sidekiq](https://github.com/mperham/sidekiq)
- [tailwindcss](https://github.com/IcaliaLabs/tailwindcss-rails)
- [webpacker](https://github.com/rails/webpacker)

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
- Foreman support thanks to a `Profile`. Once you scaffold the template, run `foreman start` to initalize and head to `locahost:5000` to get `rails server`, `sidekiq` and `webpack-dev-server` running all in one terminal instance. Note: Webpack will still compile down with just `rails server` if you don't want to use Foreman.
- A custom scaffold view template when generating theme resources (Work in progress).
- Git initialization out of the box
