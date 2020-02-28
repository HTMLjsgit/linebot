class ApplicationController < ActionController::Base
	before_action :set_request_variant
	before_action :user
	def user
		puts "\n\n============ユーザーエージェントをリクエストする=============================\n" + request.user_agent + "\n=================================\n\n\n"
		puts "===========ユーザーのOS================================\n" + request.os + "\n==========================================\n\n\n"
		puts "========ユーザーのブラウザ========================\n" + request.browser + "\n==========================================\n\n\n"
		puts "==============ｐｃからリクエスト========================\n" + request.from_pc?.to_s + "\n===================================\n\n\n"
		puts "=========スマートフォンからリクエスト=========================\n" + request.from_smartphone?.to_s + "\n========================================\n\n\n"
		puts "========ユーザーのIP========================\n" + request.ip + "\n=================================\n\n\n"
	end
	private
  	 def set_request_variant
    	request.variant = request.device_variant # :pc, :smartphone
  	 end
end
