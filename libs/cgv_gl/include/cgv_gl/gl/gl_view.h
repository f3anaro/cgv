#pragma once

#include <cgv/render/view.h>
#include <cgv/media/axis_aligned_box.h>
#include "lib_begin.h"

namespace cgv {
	namespace render {
		
		class context;

		namespace gl {


/** extends the view class with the following quantities:

    - z_near ... position of the near clipping plane
    - z_far  ... position of the far clipping plane
*/
class CGV_API gl_view : public view
{
public:
	typedef media::axis_aligned_box<double,3> box_type;
protected:
	double z_near;
	double z_far;
	box_type scene_extent;
public:
	/// construct a parallel view with focus in the world origin looking in negative z-direction and the y-direction as up-direction with an extent of +-1
	gl_view();
	/// compute clipping planes adapted to the current scene extent, z_near_derived is at least z_near and as large as possible to include the scene, similarly z_far_derived is as small as possible  
	void compute_clipping_planes(double& z_near_derived, double& z_far_derived, bool clip_relative_to_extent = false) const;
	/// compute clipping planes according to given view adapted to the current scene extent, z_near_derived is at least z_near and as large as possible to include the scene, similarly z_far_derived is as small as possible  
	void compute_clipping_planes(const cgv::render::view& view, double& z_near_derived, double& z_far_derived, bool clip_relative_to_extent = false) const;

	/**@name getter and setter methods*/
	//@{
	/// return the currently set z-value for the z-near clipping plane
	double get_z_near() const;
	///set the z-value for the z-near clipping plane
	virtual void set_z_near(double z);
	/// return the currently set z-value for the z-far clipping plane
	double get_z_far() const;
	/// set the z-value for the z-far clipping plane
	virtual void set_z_far(double z);
	/// transform a z value in eye-coordinates (should be negative!) to device coordinate
	static double get_z_D(double z_eye, double z_near, double z_far);
	/// set the extent of the scene in world coordinates used by the compute_clipping_planes functions to adapt the clipping planes to the scene
	virtual void set_scene_extent(const box_type& _box);
	/// return the currently set scene extent
	box_type get_scene_extent() const;
	/// reset view with focus and y-extent based on current scene extent
	virtual void set_default_view();
	//@}
};
		}
	}
}

#include <cgv/config/lib_end.h>