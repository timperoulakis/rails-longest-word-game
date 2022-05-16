require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Games"
  # end
  test "grid has 10 letters" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "grid changes every time" do
    visit new_url
    letters = page.all("li").map(&:text)
    visit new_url
    letters2 = page.all("li").map(&:text)
    assert letters != letters2
  end

  test "checks if the word is contained in the generated grid" do
    word = "superfluous"
    visit new_url
    fill_in "word", with: word
    click_on "Play"
    assert_text "Sorry but #{word} can't be built out of"
    assert_text "Score: 0"
  end

  test "checks if the word is valid" do
    visit new_url
    letters = page.all("li").map(&:text)
    word = letters.shuffle.join
    fill_in "word", with: word
    click_on "Play"
    assert_text "Sorry but #{word} does not seem to be a valid English word"
    assert_text "Score: 0"
  end

  test "congratulates when the word is valid and computes a score" do
    visit new_url
    letter = page.all("li").map(&:text).sample
    fill_in "word", with: letter
    click_on "Play"
    assert_text "Congratulations"
    assert_text(/Score: [^0]/)
  end

  test "total score adds up" do
    visit new_url
    letter = page.all("li").map(&:text).sample
    fill_in "word", with: letter
    click_on "Play"
    total_score = page.find("#total-score").text[/\d+/].to_i
    visit new_url
    letter = page.all("li").map(&:text).sample
    fill_in "word", with: letter
    click_on "Play"
    total_score2 = page.find("#total-score").text[/\d+/].to_i
    assert total_score2 > total_score
  end
end
