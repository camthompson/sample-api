class PagesController < ApplicationController
  def index
    index_key = if params['rev']
                  "index.html:#{params['rev']}"
                else
                  'index.html'
                end
    render text: S3Storage.new.index_for_key(index_key)
  end

  class S3Storage
    def index_for_key(key)
      index_bucket.files.head(key).body
    end

    def index_bucket
      storage.directories.get(ENV['INDEX_BUCKET'])
    end

    def storage
      @storage ||= Fog::Storage.new({
        provider: 'aws',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      })
    end
  end
end
