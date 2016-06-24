class BooksController < ApplicationController
  before_action :authenticate_user!

  before_action :set_book, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  def upvote
    @book = Book.find(params[:id])
    if current_user.voted_up_on? @book
      @book.unliked_by current_user
    else
      @book.liked_by current_user
    end
    @book.like_count = @book.get_upvotes.size
    @book.hate_count = @book.get_downvotes.size
    @book.save

    @user = current_user
    new_like_voted = []
    current_user.find_up_voted_items.each do |voted|
      new_like_voted << voted.title.to_s
    end
    new_hate_voted = []
    current_user.find_down_voted_items.each do |voted|
      new_hate_voted << voted.title.to_s
    end
    @user.like_array = new_like_voted
    @user.hate_array = new_hate_voted
    @user.save
    redirect_to books_path
  end

  def downvote
    @book = Book.find(params[:id])
    if current_user.voted_down_on? @book
      @book.undisliked_by current_user
    else
      @book.downvote_from current_user
    end
    @book.like_count = @book.get_upvotes.size
    @book.hate_count = @book.get_downvotes.size
    @book.save

    @user = current_user
    new_like_voted = []
    current_user.find_up_voted_items.each do |voted|
      new_like_voted << voted.title.to_s
    end
    new_hate_voted = []
    current_user.find_down_voted_items.each do |voted|
      new_hate_voted << voted.title.to_s
    end
    @user.like_array = new_like_voted
    @user.hate_array = new_hate_voted
    @user.save

    redirect_to books_path
  end

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:title, :description, :image)
  end
end
