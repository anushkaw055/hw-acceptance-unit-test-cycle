require 'rails_helper.rb'

describe MoviesController, :type => :controller do
    describe 'Find Movies With Same Director' do
        it 'calls the model method that performs finding movies with same director' do
            expect(Movie).to receive(:find_similar_movies).with('1')
            #Movie.should_receive(:find_similar_movies).with("1")
            get :director, {:id => '1'}
        end
        it 'selects the find similar movies template for rendering' do
            @movies = [double('Movie'), double('Movie')]
            Movie.stub(:find_similar_movies).and_return(@movies)
            get :director, {:id => '1'}
            expect(response).to render_template(:director)
        end
        it 'makes find similar movies available to template' do
            @movies = [double('Movie'), double('Movie')]
            @movie = double('Movie')
            Movie.stub(:find_similar_movies).and_return([@movies,0,@movie])
            get :director, {:id => '1'}
            assigns(:movie).should == @movie
            assigns(:movies).should == @movies
        end
        it 'makes find similar movies available to template sad path' do
            @movie = double('Movie', :title => 'MovieRandom')
            Movie.stub(:find_similar_movies).and_return([nil,1,@movie])
            get :director, {:id => '1'}
            expect(response).to redirect_to movies_path
            flash[:notice].should eq("'#{@movie.title}' has no director info.")
        end
    end
    describe "Sorting movies according to tile and release date" do
        it "sort according to movie title" do 
            get :index, sort: "title"
            expect(response.body).to include "title"
        end
        it "sort according to release date" do 
            get :index, sort: "release_date"
            expect(response.body).to include "release_date"
        end 
    end
    describe "Sorting movies according to rating" do
        it "sort movies according to rating" do 
            @ratings={"G"=>"1", "NC-17"=>"1", "R"=>"1"}
            get :index, ratings: @ratings
            expect(response.body).to include "ratings"
            expect(response.body).to include "G"
            expect(response.body).to include "R"
            expect(response.body).to include "NC-17"
        end
    end