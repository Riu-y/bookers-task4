class BooksController < ApplicationController
  before_action :authenticate_user! , only: [:show, :new, :edit, :index, :new]
  def show
  	@bookdetail = Book.find(params[:id])
    @book = Book.new
    @user = User.find(@bookdetail.user_id)
    @post_comment = PostComment.new
    @post_comments = PostComment.all
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book = Book.new
    @user = current_user
  end
  def new
    @book = Book.new
  end
  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		redirect_to @book, notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
      flash[:notice] = "Error !!"
  		@books = Book.all
  		render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
    redirect_to books_path unless @book.user_id == current_user.id
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render "edit"
  	end
  end

  def destroy
  	@book = Book.find(params[:id])
  	@book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body, :user_id)
  end
end
