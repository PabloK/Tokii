class CollisionSupervisor
  
  def initialize moving_objects, stale_objects
    @moving_objects = moving_objects
    @stale_objects = stale_objects
  end
  
  def collide!
    for object in @moving_objects do
      for stale in @stale_objects do
        object.scollide? stale
      end
    end
  end
  
end
