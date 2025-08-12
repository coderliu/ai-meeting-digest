class Transcript < ApplicationRecord
  include Turbo::Broadcastable

  enum :status, [ :initial, :done, :interrupted ]

  validates :input, presence: true

  after_create_commit { GenerateOutputJob.perform_later(self) }

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
