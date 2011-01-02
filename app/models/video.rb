class Video < ActiveRecord::Base

  VIDEO_DIR     = '/var/media/movie'

  ENCODE_SUFFIX = ' - airvideo'
  ENCODE_EXT    = '.m4v'

  def self.parse(url)
    downloader = Downloader.parse url
    video = self.new
    video.url = downloader.url
    video.title = downloader.title
    video.video_url = downloader.video_url
    video.download_path =
      File.join VIDEO_DIR, download_filename(video.title, video.video_url)
    video.encoded_path =
      File.join VIDEO_DIR, encoded_filename(video.title, video.video_url)
    video
  end

  def self.recent
    find(:all,
         conditions: ['downloaded = ? and encoded = ?', true, true],
         order: 'id desc',
         limit: 10)
  end

  def self.filename(title)
    title.split(' ').map(&:downcase).join('_')
  end

  def self.extname(video_url)
    File.extname(video_url).split(%r{[?&]}).first
  end

  def self.download_filename(title, video_url)
    "#{filename(title)}#{extname(video_url)}"
  end

  def self.encoded_filename(title, video_url)
    "#{filename(title)}#{ENCODE_SUFFIX}#{ENCODE_EXT}"
  end

end
