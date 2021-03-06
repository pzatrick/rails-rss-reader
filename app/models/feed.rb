require 'digest/md5'

class Feed < ActiveRecord::Base
  has_many :entries, :dependent => :destroy

  validates :url, uniqueness: true

  def secret
    Digest::MD5.hexdigest(url)
  end

  def notified(params)
    update_attributes(
      :status => params["status"]["http"],
      :title => params["status"]["title"]
    )

  	params['items'].each do |item|
  		entries.create(
        :atom_id => item["id"], 
        :title => item["title"], 
        :url => item["permalinkUrl"], 
        :content => item["content"]
      )
  	end
  end
end
