# encoding: UTF-8

require 'stringio'
class MagzinesController < ApplicationController
  before_filter :authenticate, :only => [:show]
  before_filter :editor_or_editor_manager_or_supervisor_authenticate, :only => [:show]
  
  def index
    @title = "刊期"
  end
  
  def show
    # 统计信息
    @total = 0
    @finished = 0
    @delay_material = 0
    @delay_draft = 0
    @delay_final = 0
    articles = Article.where(:no=>params[:no])
    articles.each do |article|
      @total += 1
      if !article.print_at.nil? || article.closed
        @finished += 1
      end
      if !article.material_on.nil? && !article.material_at.nil? && article.material_on < Date.new(article.material_at.year, article.material_at.month, article.material_at.day)
        @delay_material += 1
      end
      if !article.draft_on.nil? && !article.draft_at.nil? && article.draft_on < Date.new(article.draft_at.year, article.draft_at.month, article.draft_at.day)
        @delay_draft += 1
      end
      if !article.final_on.nil? && !article.final_at.nil? && article.final_on < Date.new(article.final_at.year, article.final_at.month, article.final_at.day)
        @delay_final += 1
      end
    end
    # 报销单据
    if editor_manager_user? || supervisor_user? || admin_user?
      expenses = Expense.includes(:user, :article).joins(:article).where(:articles => {:no => params[:no]})
    else
      expenses = Expense.includes(:user, :article).joins(:article).where(:articles => {:no => params[:no]}, :user_id=>current_user.id)
    end
    @expenses = {}
    expenses.each do |expense|
      @expenses[expense.user.name] = {} unless @expenses.has_key?(expense.user.name)
      @expenses[expense.user.name][expense.exp_type] = {} unless @expenses[expense.user.name].has_key?(expense.exp_type)
      key = "#{expense.author}#{expense.idcard}"
      @expenses[expense.user.name][expense.exp_type][key] = [] unless @expenses[expense.user.name][expense.exp_type].has_key?(key)
      @expenses[expense.user.name][expense.exp_type][key] << expense
    end
    y,m,d = params[:no].split('-')
    @title = "#{y}年#{m}月刊"
  end
  
  def export_excel
    #e = Excel::Workbook.new
    book = Spreadsheet::Workbook.new
    y,m,d = params[:no].split('-')
    @title = "#{y}年#{m}月刊"
    if editor_manager_user? || supervisor_user? || admin_user?
      expenses = Expense.includes(:user, :article).joins(:article).where(:articles => {:no => params[:no]})
    else
      expenses = Expense.includes(:user, :article).joins(:article).where(:articles => {:no => params[:no]}, :user_id=>current_user.id)
    end
    @expenses = {}
    expenses.each do |expense|
      @expenses[expense.user.name] = {} unless @expenses.has_key?(expense.user.name)
      @expenses[expense.user.name][expense.exp_type] = {} unless @expenses[expense.user.name].has_key?(expense.exp_type)
      key = "#{expense.author}#{expense.idcard}"
      @expenses[expense.user.name][expense.exp_type][key] = [] unless @expenses[expense.user.name][expense.exp_type].has_key?(key)
      @expenses[expense.user.name][expense.exp_type][key] << expense
    end
    @expenses.each do |editor, exp_types|
      sheet = book.create_worksheet :name => editor
      sheet.row(0).concat %w{职业 联系人 真实姓名 电邮 身份证 篇目 字数 稿酬(元/千字) 页数 稿酬(元/张) 应付金额 税额 实领金额 银行账号 开户行}
      rownum = 1
      exp_types.each do |exp_type, expenses|
        expenses.each do |key, exps|
          total_fee = 0; tax = 0; paid = 0
          exps.each do |expense|
            total_fee +=expense.total_fee unless expense.total_fee.nil?
            paid += expense.paid unless expense.paid.nil?
            tax += expense.tax unless expense.tax.nil?
            sheet.row(rownum).replace [
              exp_type == 0 ? Constants::Careers[expense.career] : "N/A", 
              expense.author, 
              exp_type == 0 ? expense.realname : "N/A",
              expense.email,
              expense.idcard,
              expense.article.subject,
              (exp_type == 0 && !expense.text_count.nil?) ? expense.text_count : "N/A",
              (exp_type == 0 && !expense.fee_per_word.nil?) ? expense.fee_per_word : "N/A",
              (exp_type == 0 && !expense.pages.nil?) ? expense.pages : "N/A", 
              (exp_type == 0 && !expense.fee_per_page.nil?) ? expense.fee_per_page : "N/A", 
              expense.total_fee, 
              expense.tax, 
              expense.paid, 
              expense.bankno, 
              expense.bank
            ]
            rownum += 1
          end
        end
      end
      #e.addWorksheetFromArrayOfHashes(editor, array)
    end
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = "attachment; filename=\"#{@title}.xls\""
    headers['Cache-Control'] = ''
    io = StringIO.new('')
    book.write(io)
    render :text=>io.string
  end

end
