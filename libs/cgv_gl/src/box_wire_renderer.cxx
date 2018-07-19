#include <cgv_gl/box_wire_renderer.h>
#include <cgv_gl/gl/gl.h>
#include <cgv_gl/gl/gl_tools.h>

namespace cgv {
	namespace render {

		/// overload to allow instantiation of box_wire_renderer
		render_style* box_wire_renderer::create_render_style() const
		{
			return new line_render_style();
		}

		box_wire_renderer::box_wire_renderer()
		{
			has_extents = false;
			position_is_center = true;
		}
		/// set the flag, whether the position is interpreted as the box center
		void box_wire_renderer::set_position_is_center(bool _position_is_center)
		{
			position_is_center = _position_is_center;
		}


		bool box_wire_renderer::init(context& ctx)
		{
			bool res = renderer::init(ctx);
			if (!ref_prog().is_created()) {
				if (!ref_prog().build_program(ctx, "box_wire.glpr", true)) {
					std::cerr << "ERROR in box_wire_renderer::init() ... could not build program box_wire.glpr" << std::endl;
					return false;
				}
			}
			return res;
		}
		bool box_wire_renderer::validate_attributes(context& ctx)
		{
			// validate set attributes
			bool res = line_renderer::validate_attributes(ctx);
			if (!has_extents) {
				ctx.error("box_renderer::enable() extent attribute not set");
				res = false;
			}
			return res;
		}
		/// 
		bool box_wire_renderer::enable(context& ctx)
		{
			if (!line_renderer::enable(ctx))
				return false;
			ref_prog().set_uniform(ctx, "position_is_center", position_is_center);
			return true;
		}
	}
}