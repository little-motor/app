class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)} # 设置默认排序方式->接受一个代码块，返回一个Proc对象
  mount_uploader :picture, PictureUploader
  validates :user_id,presence: true
  validates :content,presence: true,length: { maximum: 140 }
  #调用自己定义的验证方法为validate
  validate :picture_size

    private

      # 验证上传的图像大小 
      def picture_size
        if picture.size > 5.megabytes 
          errors.add(:picture, "should be less than 5MB")
        end 
      end
end
