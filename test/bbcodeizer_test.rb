require 'test/unit'
require 'bbcodeizer_helper'

class BbcodeizerTest < Test::Unit::TestCase
  include BBCodeizeHelper

  def test_quote_with_cite
    assert_equal(
      "<blockquote><p><cite>\"JD\" wrote:</cite></p>\nBBCode is great!\n</blockquote>",
      bbcodeize("[quote=\"JD\"]\nBBCode is great!\n[/quote]"))
  end

  def test_quote_sans_cite
    assert_equal(
      "<blockquote>\nBBCode is great!\n</blockquote>",
      bbcodeize("[quote]\nBBCode is great!\n[/quote]"))
  end

  def test_nested_quote_sans_cite
    assert_equal(
      "<blockquote>\n<blockquote>\nBBCode is great!</blockquote>\nYes it is!\n</blockquote>",
      bbcodeize("[quote]\n[quote]\nBBCode is great![/quote]\nYes it is!\n[/quote]"))
  end

  def test_code
    assert_equal(
      "<pre><code>\ncode goes here\n</code></pre>",
      bbcodeize("[code]\ncode goes here\n[/code]"))
  end

  def test_bold
    assert_equal(
      "I am <strong>really</strong> happy!",
      bbcodeize("I am [b]really[/b] happy!"))
  end

  def test_italic
    assert_equal(
      "Have you read <em>Catcher in the Rye</em>?",
      bbcodeize("Have you read [i]Catcher in the Rye[/i]?"))
  end

  def test_underline
    assert_equal(
      "<u>Please note</u>:",
      bbcodeize("[u]Please note[/u]:"))
  end

  def test_email_with_name
    assert_equal(
      "You can also <a href=\"mailto:jd@example.com\">contact me by e-mail</a>.",
      bbcodeize("You can also [email=jd@example.com]contact me by e-mail[/email]."))
  end

  def test_email_sans_name
    assert_equal(
      "My email address is <a href=\"mailto:jd@example.com\">jd@example.com</a>",
      bbcodeize("My email address is [email]jd@example.com[/email]"))
  end

  def test_url_with_title
    assert_equal(
      "Check out <a href=\"http://www.rubyonrails.com\" target=\"_blank\">Ruby on Rails</a>!",
      bbcodeize("Check out [url=http://www.rubyonrails.com]Ruby on Rails[/url]!"))
  end

  def test_url_sans_title
    assert_equal(
      "My homepage is <a href=\"http://www.example.com\" target=\"_blank\">http://www.example.com</a>.",
      bbcodeize("My homepage is [url]http://www.example.com[/url]."))
  end

  def test_auto_link
    assert_equal(
      "Check out this site: <a href=\"http://google.com\" target=\"_blank\">http://google.com</a>",
      bbcodeize("Check out this site: http://google.com"))
  end

  def test_auto_link_nested
    assert_equal(
      "<b><a href=\"http://google.com\" target=\"_blank\">http://google.com</a></b>",
      bbcodeize("<b>http://google.com</b>"))
  end

  def test_image
    assert_equal(
      "<img src=\"http://example.com/example.gif\" alt=\"http://example.com/example.gif\" />",
      bbcodeize("[img]http://example.com/example.gif[/img]"))
  end

  def test_uneven_quotes
    assert_equal(
      "[quote]A[quote]B[/quote]C[quote]D[/quote]",
      bbcodeize("[quote]A[quote]B[/quote]C[quote]D[/quote]"))
  end

  def test_even_nesting
    assert_equal(
      "<u><strong>Very important!</strong></u>",
      bbcodeize("[u][b]Very important![/b][/u]"))
  end

  def test_uneven_nesting
    assert_equal(
      "<u><strong>Very</u> important!</strong>",
      bbcodeize("[u][b]Very[/u] important![/b]"))
  end

  def test_size
    assert_equal(
      "<span style=\"font-size: 32px\">Big Text</span>",
      bbcodeize("[size=32]Big Text[/size]"))
  end

  def test_color
    assert_equal(
      "<span style=\"color: red\">Red Text</span>",
      bbcodeize("[color=red]Red Text[/color]"))
  end

  def test_disable
    assert_equal(
      "I am [b]really[/b] happy!",
      bbcodeize("I am [b]really[/b] happy!", :disabled => [ :bold ]))
    assert_equal(
      "I am <strong>really</strong> happy!",
      bbcodeize("I am [b]really[/b] happy!", :disabled => [ :video ]))
  end

  def test_deactivation
    BBCodeizer.deactivate(:bold)
    assert_equal(
      "I am [b]really[/b] happy!",
      bbcodeize("I am [b]really[/b] happy!"))
    BBCodeizer.activate(:bold) # for future tests
  end

  def test_activation
    BBCodeizer.deactivate(:bold)
    BBCodeizer.activate(:bold)
    assert_equal(
      "I am <strong>really</strong> happy!",
      bbcodeize("I am [b]really[/b] happy!"))
  end
end
