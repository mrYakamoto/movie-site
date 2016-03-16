# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# user_seeds = {
#   "mr.gregory" => "gregg@gmail.com",
#   "balthasar" => "balthasar@yahoo.com",
#   "mryakamoto" => "mryakamoto@me.com",
#   "buddylee" => "buddylee@aol.com"
# }

# film_seeds = {
#   "Carol" => "assets/seed_posters/carol.jpg",
#   "Her" => "assets/seed_posters/her.jpg",
#   "The Rocketeer" => "assets/seed_posters/the_rocketeer.jpg",
#   "White Christmas" => "assets/seed_posters/white_christmas.jpg",
#   "The Witch" => "assets/seed_posters/the_witch.jpg",
#   "Hot Fuzz" => "assets/seed_posters/hot_fuzz.jpg"
# }

theater_seeds = {
  "Roxie Theater" => {
    "address" => "3117 16th Street, San Francisco, CA",
    "website_url" => "www.roxie.com"
    },
    "Yerba Buena Center for the Arts" => {
      "address" => "701 Mission Street San Francisco, CA 94103",
      "website_url" => "http://www.ybca.org/"
    }
  }

  # def create_users(user_seeds)
  #   puts "="*5 << "SEEDING-USERS" << "="*5
  #   user_seeds.keys.each do |username|
  #     username = username
  #     email = user_seeds[username]
  #     User.create!(username: username, email: email, password: "password")
  #     puts "User: #{username} created"
  #   end
  # end

  # def create_films(film_seeds)
  #   puts "="*5 << "SEEDING-FILMS" << "="*5
  #   film_seeds.keys.each do |film_title|
  #     title = film_title
  #     poster_url = film_seeds[film_title]
  #     Film.create!(title: title, poster_url: poster_url)
  #     puts "Film: #{title} created"
  #   end
  # end

  def create_theaters(theater_seeds)
    puts "="*5 << "SEEDING-THEATERS" << "="*5
    theater_seeds.keys.each do |theater_name|
      name = theater_name
      address = theater_seeds[theater_name]["address"]
      website_url = theater_seeds[theater_name]["website_url"]
      Theater.create!(name: name, address: address, website_url: website_url)
      puts "Theater: #{name} created"
    end
  end


# DateTime.new(2012, 07, 11, 20, 10, 0)
# => Wed, 11 Jul 2012 20:10:00 +0000



# def create_screenings()
#   puts "="*5 << "SEEDING-SCREENINGS" << "="*5
#   Film.all.each do |film_obj|
#     3.times do
#       time = DateTime.new(2016,03,rand(1..31),rand(11..23),rand(1..59),0)
#       month = time.month.to_s
#       theater_id = rand(1..2)
#       film_obj.screenings.create!(date_time: time, month: month,ticketing_url: "#", theater_id: theater_id)
#       puts "Screening for #{film_obj.title} on #{time} created"
#     end
#   end
# end

# create_users(user_seeds)
# create_films(film_seeds)
create_theaters(theater_seeds)
# create_screenings
