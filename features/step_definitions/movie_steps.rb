# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.

    # add movie using ActiveRecord
    Movie.create movie
  end

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.

  # get indexes of both movies
  e1pos = page.body.index e1
  e2pos = page.body.index e2

  # if either are nil, then they weren't found on the page
  if e1pos == nil || e2pos == nil then
    flunk "Movie not mentioned on page"
  else
    # if the second movie came before the first, then they are the wrong order
    if e1pos >= e2pos then
      flunk "Movies are not in the correct order"
    end
  end

end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  # split string into component parts
  pa = rating_list.split(",")

  # for all ratings listed, check or uncheck them
  pa.each { |rating|
    rating = "ratings_" + rating.tr('" ', '')
    if uncheck then
      uncheck rating
    else
      check rating
    end
  }

end

Then /I should see all of the movies/ do

  # count the number of movie title matches found in the page
  count = 0
  page.body.scan(">More about ") { |match| count = count + 1 }

  # get the number of movies in the table
  q = Movie.select("count(*) as num_rows").first

  # if the counts match, that's great
  if q.num_rows != count then
    flunk "Incorrect number of movies seen (expected #{q.num_rows} but found #{count})"
  end

end

Then /I should see no movies/ do

  # count the number of movie title matches found in the page
  count = 0
  page.body.scan(">More about ") { |match| count = count + 1 }

  # if the counts was zero (no movies), that's great
  if count != 0 then
    flunk "Incorrect number of movies seen (expoected 0 but found #{count})"
  end

end
