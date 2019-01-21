#pragma once

#include "group_renderer.h"
#include <cgv_reflect_types/media/illum/textured_surface_material.h>
#include <cgv/media/illum/textured_surface_material.h>

#include "gl/lib_begin.h"

namespace cgv { // @<
	namespace render { // @<


		/** style of a point */
		struct CGV_API surface_render_style : public group_render_style
		{
			/// default value for color when map color to material is used
			cgv::media::illum::surface_material::color_type surface_color;
			/// culling mode for point splats, set to CM_OFF in constructor
			CullingMode culling_mode;
			/// illumination mode defaults to \c IM_ONE_SIDED
			IlluminationMode illumination_mode;
			/// material side[s] where color is to be mapped to the diffuse material component, defaults to MS_FRONT_AND_BACK
			cgv::render::MaterialSide map_color_to_material;
			/// material of surface
			cgv::media::illum::textured_surface_material material;
			///
			surface_render_style();
		};

		/// base classes for renderers that support surface rendering
		class CGV_API surface_renderer : public group_renderer
		{
		protected:
			bool has_normals;
			bool has_texcoords;
			bool cull_per_primitive;
		public:
			surface_renderer();
			/// 
			bool enable(context& ctx);
			///
			bool disable(context& ctx);
			/// templated method to set the normal attribute array from a vector of normals of type T, which should have 3 components
			template <typename T>
			void set_normal_array(const context& ctx, const std::vector<T>& normals) { has_normals = true;  set_attribute_array(ctx, ref_prog().get_attribute_location(ctx, "normal"), normals); }
			/// templated method to set the normal attribute from an array of normals of type T, which should have 3 components
			template <typename T>
			void set_normal_array(const context& ctx, const T* normals, size_t nr_elements, size_t stride_in_bytes = 0) { has_normals = true;  set_attribute_array(ctx, ref_prog().get_attribute_location(ctx, "normal"), normals, nr_elements, stride_in_bytes); }
			/// method to set the normal attribute from a vertex buffer object, the element type must be given as explicit template parameter
			void set_normal_array(const context& ctx, type_descriptor element_type, const vertex_buffer& vbo, size_t offset_in_bytes, size_t nr_elements, size_t stride_in_bytes = 0);
			/// template method to set the normal attribute from a vertex buffer object, the element type must be given as explicit template parameter
			template <typename ElementType>
			void set_normal_array(const context& ctx, const vertex_buffer& vbo, size_t offset_in_bytes, size_t nr_elements, size_t stride_in_bytes = 0) { set_normal_array(ctx, type_descriptor(element_descriptor_traits<T>::get_type_descriptor(T()), true), vbo, offset_in_bytes, nr_elements, stride_in_bytes); }
			/// templated method to set the texcoord attribute array from a vector of texcoords of type T
			template <typename T>
			void set_texcoord_array(const context& ctx, const std::vector<T>& texcoords) { has_texcoords = true;  set_attribute_array(ctx, ref_prog().get_attribute_location(ctx, "texcoord"), texcoords); }
			/// templated method to set the texcoord attribute from an array of texcoords of type T
			template <typename T>
			void set_texcoord_array(const context& ctx, const T* texcoords, size_t nr_elements, size_t stride_in_bytes = 0) { has_texcoords = true;  set_attribute_array(ctx, ref_prog().get_attribute_location(ctx, "texcoord"), texcoords, nr_elements, stride_in_bytes); }
			/// template method to set the texcoord attribute from a vertex buffer object, the element type must be given as explicit template parameter
			void set_texcoord_array(const context& ctx, type_descriptor element_type, const vertex_buffer& vbo, size_t offset_in_bytes, size_t nr_elements, size_t stride_in_bytes = 0);
			/// template method to set the texcoord attribute from a vertex buffer object, the element type must be given as explicit template parameter
			template <typename ElementType>
			void set_texcoord_array(const context& ctx, const vertex_buffer& vbo, size_t offset_in_bytes, size_t nr_elements, size_t stride_in_bytes = 0) { set_texcoord_array(ctx, type_descriptor(element_descriptor_traits<T>::get_type_descriptor(T()), true), vbo, offset_in_bytes, nr_elements, stride_in_bytes); }
		};
	}
}

namespace cgv {
	namespace reflect {
		namespace render {
			struct CGV_API surface_render_style : public cgv::render::surface_render_style
			{
				bool self_reflect(cgv::reflect::reflection_handler& rh);
			};
		}

#ifdef REFLECT_IN_CLASS_NAMESPACE
}} namespace cgv { namespace render {
#endif

		extern CGV_API cgv::reflect::extern_reflection_traits<cgv::render::surface_render_style, cgv::reflect::render::surface_render_style> get_reflection_traits(const cgv::render::surface_render_style&);
	}
}

#include <cgv/config/lib_end.h>