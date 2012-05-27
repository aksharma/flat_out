jeweler --rspec --create-repo flat_out
cd flat_out
create git_it.sh -> git push origin
vi Gemfile and change rcov to simplecov >= 0.5
bundle install
create and edit flat_out.gemspec
gem build flat_out.gemspec
gem push flat_out-0.0.1.gem
sharma.ruby1git@sh.a3
autotest


