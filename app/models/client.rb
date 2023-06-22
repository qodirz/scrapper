class Client < ApplicationRecord
  enum platform: {
    jam_tangan: 0
  }

  def self.platform_options
    platforms.keys.map{ |key| [key.titleize, key] }
  end
end
