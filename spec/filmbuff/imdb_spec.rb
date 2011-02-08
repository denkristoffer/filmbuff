# encoding: utf-8
$:.push File.expand_path("../../../lib", __FILE__)
require "filmbuff"

describe Filmbuff::IMDb do
  before :all do
    @imdb = Filmbuff::IMDb.new
  end

  describe "#locale" do
    it "returns the locale" do
      @imdb.locale.should == "en_US"
    end
  end

  describe "#locale=" do
    context "given valid locale" do
      it "does not raise an exception" do
        lambda { @imdb.locale = "fr_FR" }.should_not
          raise_error(Filmbuff::IMDbInvalidLocale)
      end

      it "sets locale to the given value" do
        @imdb.locale = "de_DE"
        @imdb.locale.should == "de_DE"
      end
    end

    context "given invalid locale" do
      it "raises an exception" do
        lambda { @imdb.locale = "da_DK" }.should
          raise_error(Filmbuff::IMDbInvalidLocale)
      end
    end
  end

  describe "#request" do
    context "given \"/hello\" function" do
      context "given valid arguments" do
        before :all do
          @arguments = {
            "system_name" => "iPhone OS",
            "system_version" => "3.1.2"
          }
        end

        it "returns \"ok\" as status" do
          status = @imdb.request("/hello", @arguments)
          status["data"]["status"].should == "ok"
        end

        it "does not raise an exception" do
          lambda { @imdb.request("/hello", @arguments) }.should_not
            raise_error(Filmbuff::IMDbRequestError)
        end
      end

      context "given a wrong argument type" do
        context "given an integer" do
          it "raises an exception" do
            lambda { @imdb.request("/hello", 1) }.should
              raise_error(Filmbuff::IMDbInvalidArgument)
          end
        end

        context "given a string" do
          it "raises an exception" do
            lambda { @imdb.request("/hello", "string") }.should
              raise_error(Filmbuff::IMDbInvalidArgument)
          end
        end

        context "given an array" do
          it "raises an exception" do
            lambda { @imdb.request("/hello", %q{a b}) }.should
              raise_error(Filmbuff::IMDbInvalidArgument)
          end
        end
      end

      context "given nonexistent function" do
        it "raises an exception" do
          lambda { @imdb.request("/nonexistent") }.should
            raise_error(Filmbuff::IMDbInvalidArgument)
        end
      end
    end
  end
end