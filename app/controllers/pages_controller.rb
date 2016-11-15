class PagesController < ApplicationController
  def index
    index_key = if params['rev']
                  "index.html:#{params['rev']}"
                else
                  'index.html'
                end
    render text: FogConnection.new.index_for_key(index_key)
  end

  class FogConnection
    attr_reader :storage

    def initialize
      @storage = Fog::Storage.new({
        provider: 'aws',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      })
    end

    def index_for_key(key)
      index_bucket.files.head(key).body
    end

    def index_bucket
      storage.directories.get(ENV['INDEX_BUCKET'])
    end
  end
end
