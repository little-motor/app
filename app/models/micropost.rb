class Micropost < ApplicationRecord
  #################################################################
  #单数
  belongs_to :user
  # 设置默认排序方式->接受一个代码块，返回一个Proc对象
  #这个是Proc类lambda表达式的另一种写法->(块变量){处理}
  default_scope -> { order(created_at: :desc)} 

  #验证外键
  validates :user_id,presence: true

  #验证内容
  validates :content,presence: true,length: { maximum: 140 }
  
  #调用自己定义的验证方法为validate
  validate :picture_size

   mount_uploader :picture, PictureUploader
  ############################################################
    private

      # 验证上传的图像大小 
      def picture_size
        if picture.size > 5.megabytes 
          errors.add(:picture, "should be less than 5MB")
        end 
      end
end
