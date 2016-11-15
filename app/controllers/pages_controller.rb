class PagesController < ApplicationController
  def index
    html = index_html
    render text: FogConnection.new
  end

  def index_html
    fog_connection.index_for_key(index_key)
  end

  def index_key
    if params['rev']
      "index.html:#{params['rev']}"
    else
      'index.html'
    end
  end

  class FogConnection
    attr_reader :storage

    def initialize
      @storage = Fog::Storage.new({
        provider: ENV['FOG_PROVIDER'],
        local_root: ENV['FOG_LOCAL_ROOT'],
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        endpoint: ENV['FOG_LOCAL_ROOT']
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
