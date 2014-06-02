class StatusesController < ApplicationController
  def index
    @status = Status.new
  end

  def detail
    if status_params == false
      redirect_to(:action => 'index')
    else
      @status = Status.new(status_params)
      #put this in index.html.erb <% @cmd.lines.each do |line|%> <td><%= line %></td> <% end %>
      #@cmd = #%x[ ssh -X timc@fred.cchem.berkeley.edu ] 
      @hostname = "fred.cchem.berkeley.edu"
      @username = @status.user_name
      @password = @status.password
      @cmd = "qstat"
      @job_id = Array.new
      @prior = Array.new
      @name = Array.new
      @user = Array.new
      @state = Array.new
      @submit_date = Array.new
      @submit_time = Array.new
      @queue = Array.new
      @slots = Array.new

      begin
        ssh = Net::SSH.start(@hostname, @username, :password => @password)
        res = ssh.exec!(@cmd)
        #ssh.close
        @output = res
      rescue
        @output = "Unable to connect to #{@hostname} using #{@username} and your password input"
      end

      
      if @output == "Unable to connect to #{@hostname} using #{@username} and your password input"
        @output = @output
      else
        @output.lines[2..@output.lines.count].each do |line|

          if line.split(" ")[3].to_s == @status.user_name
            @job_id << line.split(" ")[0]
            @prior << line.split(" ")[1]
            @name << line.split(" ")[2]
            @user << line.split(" ")[3]
            @state << line.split(" ")[4]
            @submit_date << line.split(" ")[5]
            @submit_time << line.split(" ")[6]
            @queue << line.split(" ")[7]
            @slots << line.split(" ")[8]
          
          end
        end

        if @name.length == 0
          @output = false
        end
        
        @output2 = ssh.exec!("ll")
        ssh.close


      end

    end
    
 
    #%x[ perl ~/Desktop/patmatch_1.2/patmatch.pl -n GNATATNC ~/Desktop/patmatch_1.2/step-1-Brassica1kb5primeupstreamfasta.faa 0 i ]

  end

  def new
  end

  def show
  end

  def edit
  end

  def delete
  end


  private

  def status_params
    
    begin
      params.require(:status).permit(:user_name, :password)
    rescue
      return false
    end
  
  end
end

