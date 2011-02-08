# encoding: utf-8
$:.push File.expand_path("../../lib", __FILE__)
require "filmbuff"

describe Filmbuff do
  describe ".search" do
    context "given a movie title in one word" do
      before :all do
        @result = Filmbuff::search("Notorious")
      end

      it "returns popular movies first" do
        @result["data"]["results"][0]["label"].should == "Popular Titles"
      end

      it "returns the correct IMDb id" do
        @result["data"]["results"][0]["list"][0]["tconst"].should == "tt0038787"
      end
    end

    context "given a movie title in several words" do
      before :all do
        @result = Filmbuff::search("Rear Window")
      end

      it "returns popular movies first" do
        @result["data"]["results"][0]["label"].should == "Popular Titles"
      end

      it "returns the correct IMDb id" do
        @result["data"]["results"][0]["list"][0]["tconst"].should == "tt0047396"
      end
    end

    context "given a nonexistent movie title" do
      before :all do
        @result = Filmbuff::search("Rare Window")
      end

      it "returns approximate matches" do
        @result["data"]["results"][0]["label"].should ==
          "Titles (Approx Matches)"
      end

      it "returns the closest one" do
        @result["data"]["results"][0]["list"][0]["tconst"].should == "tt0499543"
      end
    end

    context "given an actor's name" do
      before :all do
        @result = Filmbuff::search("Ingrid Bergman")
      end

      it "returns popular actors first" do
        @result["data"]["results"][0]["label"].should == "Popular Names"
      end

      it "returns the correct IMDb id" do
        @result["data"]["results"][0]["list"][0]["nconst"].should == "nm0000006"
      end
    end

    context "given unicode characters" do
      it "still works" do
        pending "FIX UNICODE!"
        result = Filmbuff::search("Fucking Åmål")
        puts result["data"]
      end
    end

    context "using German locale" do
      before :all do
        @result = Filmbuff::search("Notorious", "de_DE")
      end

      it "returns most popular titles in German" do
        @result["data"]["results"][0]["label"].should == "Meistgesuchte Titel"
      end

      it "returns the German title" do
        @result["data"]["results"][0]["list"][0]["title"].should == "Berüchtigt"
      end
    end

    context "using Spanish locale" do
      before :all do
        @result = Filmbuff::search("Notorious", "es_ES")
      end

      it "returns most popular titles in Spanish" do
        @result["data"]["results"][0]["label"].should == "Títulos Populares"
      end

      it "returns the Spanish title" do
        @result["data"]["results"][0]["list"][0]["title"].should ==
          "Encadenados"
      end
    end

    context "using French locale" do
      before :all do
        @result = Filmbuff::search("Notorious", "fr_FR")
      end

      it "returns most popular titles in French" do
        @result["data"]["results"][0]["label"].should == "Titres Populaires"
      end

      it "returns the French title" do
        @result["data"]["results"][0]["list"][0]["title"].should ==
          "Les enchaînés"
      end
    end

    context "using Italian locale" do
      before :all do
        @result = Filmbuff::search("Notorious", "it_IT")
      end

      it "returns most popular titles in Italian" do
        @result["data"]["results"][0]["label"].should == "Titoli popolari"
      end

      it "returns the Italian title" do
        @result["data"]["results"][0]["list"][0]["title"].should ==
          "Notorius, l'amante perduta"
      end
    end

    context "using Portugese locale" do
      before :all do
        @result = Filmbuff::search("Notorious", "pt_PT")
      end

      it "returns most popular titles in Portugese" do
        @result["data"]["results"][0]["label"].should == "Títulos Populares"
      end

      it "returns the Portugese title" do
        @result["data"]["results"][0]["list"][0]["title"].should == "Difamação"
      end
    end
  end
end
