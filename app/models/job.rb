class Job < ApplicationRecord
  enum status: { research: 0, applied: 1, interview: 2, test: 3, offer: 4, archived: 5 }

  belongs_to :user
  belongs_to :source, optional: true
  has_many :notes, dependent: :destroy

  validates :entity, :title, :status, presence: true

  before_create :add_initial_order!

  def add_initial_order!
    self.order = (self.user.jobs.order(:order)&.last&.order || 0) + 1
  end

  def reorder_up!
    next_job = self.user.jobs.where("jobs.order > ?", self.order).order(:order).first
    self.update(order: next_job.order) if next_job
    next_job.update(order: next_job.order - 1) if next_job
    self
  end

  def reorder_down!
    next_job = self.user.jobs.where("jobs.order < ?", self.order).order(order: :desc).first
    next_job.update(order: self.order) if next_job
    self.update(order: self.order - 1) if next_job
    self
  end

end