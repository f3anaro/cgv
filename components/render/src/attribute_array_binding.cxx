#include <cgv/render/attribute_array_binding.h>
#include <cgv/render/vertex_buffer.h>

namespace cgv {
	namespace render {

bool attribute_array_binding::set_global_attribute_array(context& ctx, int loc, type_descriptor element_type, const vertex_buffer& vbo, size_t offset_in_bytes, size_t nr_elements, size_t stride_in_bytes)
{
	return ctx.set_attribute_array_void(0, loc, element_type, &vbo, reinterpret_cast<const void*>(offset_in_bytes), nr_elements, stride_in_bytes);
}

/// point array of vertex attribute at location \c loc to elements of given type in vertex buffer object at given offset spaced with given stride; in case of success also enable vertex attribute array
bool attribute_array_binding::set_attribute_array(context& ctx, int loc, type_descriptor element_type, const vertex_buffer& vbo, size_t offset_in_bytes, size_t nr_elements, size_t stride_in_bytes)
{
	return ctx.set_attribute_array_void(this, loc, element_type, &vbo, reinterpret_cast<const void*>(offset_in_bytes), nr_elements, stride_in_bytes);
}

/// check whether an attribute array is enabled
bool attribute_array_binding::is_global_array_enabled(context& ctx, int loc)
{
	return ctx.is_attribute_array_enabled(0, loc);
}

/// enable attribute array of given location
bool attribute_array_binding::enable_global_array(context& ctx, int loc)
{
	return ctx.enable_attribute_array(0, loc, true);
}
/// disable attribute array of given location
bool attribute_array_binding::disable_global_array(context& ctx, int loc)
{
	return ctx.enable_attribute_array(0, loc, false);
}

/// point array of vertex attribute at location \c loc to vertex buffer array \c array stored in CPU memory; in case of success also enable vertex attribute array
bool attribute_array_binding::set_global_attribute_array(context& ctx, int loc, const vertex_buffer& vbo, type_descriptor td, size_t size, size_t offset, size_t stride) 
{
	const void* ptr = 0;
	reinterpret_cast<size_t&>(ptr) = offset;
	return ctx.set_attribute_array_void(0, loc, td, &vbo, ptr, size, stride);
}

/** create empty shader program and set the option whether errors during
shader code attachment should be printed to std::cerr */
attribute_array_binding::attribute_array_binding()
{
}
/// call destruct method
attribute_array_binding::~attribute_array_binding()
{
	if (ctx_ptr) {
		if (ctx_ptr->make_current()) {
			destruct(*ctx_ptr);
			ctx_ptr = 0;
		}
	}
}

/// create the attribute array binding
bool attribute_array_binding::create(context& ctx)
{
	return ctx.attribute_array_binding_create(*this);
}

/// destruct attribute array
void attribute_array_binding::destruct(context& ctx)
{
	if (handle)
		ctx.attribute_array_binding_destruct(*this);
}

/// enable the attribute array binding
bool attribute_array_binding::enable(context& ctx)
{
	if (!is_created()) {
		ctx.error("attribute_array_binding::enable() attribute array binding must be created before enable", this);
		return false;
	}
	return ctx.attribute_array_binding_enable(*this);
}

/// disable the attribute array binding
bool attribute_array_binding::disable(context& ctx)
{
	return ctx.attribute_array_binding_disable(*this);
}

///
bool attribute_array_binding::enable_array(context& ctx, int loc)
{
	return ctx.enable_attribute_array(this, loc, true);
}
/// 
bool attribute_array_binding::is_array_enabled(context& ctx, int loc) const
{
	return ctx.is_attribute_array_enabled(this, loc);
}
///
bool attribute_array_binding::disable_array(context& ctx, int loc)
{
	return ctx.is_attribute_array_enabled(this, loc);
}

	}
}