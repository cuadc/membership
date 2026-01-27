<img align="right" width="250" src="https://docushare.cuadc.org/assets/CUADC%20Branding/cuadc_logo_blue.png">

# CUADC Membership System

The CUADC Membership System is a web application used by the Membership Secretary pro tempore of the Cambridge University Amateur Dramatic Club for managing the details of the society's paid up members.

The system runs as a Ruby on Rails app and speaks to a MySQL database on the backend.

## Contributing

The intention is to keep the project fairly simple and provide nothing more than a basic web frontend for the membership database. That being said, if you do notice something that's broken, could use improvement or is otherwise not working properly then please do contribute! You can submit bug reports, feature requests and pull requests on GitHub.

## Development

To get a local development environment set up you'll need to first install Ruby 3.2.2 and then follow the steps below.

```bash
git clone https://github.com/cuadc/membership.git && cd membership
cp .env.example .env
$EDITOR .env
bin/bundle config set --local deployment 'true'
bin/bundle config set --local without 'development test'
bin/bundle install
bin/rails db:prepare
bin/rails server
```

## Copyright

Copyright (c) 2020 Charlie Jonas and other contributors.\
The CUADC Membership System is released under Version 3 of the GNU General Public License.\
See the LICENSE file for full details.
