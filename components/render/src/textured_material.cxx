#include <cgv/base/base.h>
#include <cgv/render/textured_material.h>

namespace cgv {
	namespace render {

/// initialize textures
textured_material::textured_material()
{
	ctx_ptr = 0;
	alpha_test_func = AT_GREATER;
	alpha_threshold = 0.0f;

}

/// construct from obj_material
textured_material::textured_material(const media::illum::textured_surface_material& mtl)
	: media::illum::textured_surface_material(mtl)
{
	alpha_test_func = AT_GREATER;
	alpha_threshold = 0.0f;
}

/// destruct textures
textured_material::~textured_material()
{
	if (ctx_ptr && ctx_ptr->make_current())
		destruct_textures(*ctx_ptr);
}

/// call this to ensure that the textures are loaded - typically done in the init_frame method of a drawable
bool textured_material::ensure_textures(context& ctx)
{
	bool success = true;
	for (size_t ti = 0; ti < image_file_names.size(); ++ti) {
		texture* T = new texture();
		if (!T->create_from_image(ctx, image_file_names[ti])) {
			std::cerr << "could not create texture from file '" << image_file_names[ti] << "': " << T->get_last_error() << std::endl;
			delete T;
			T = 0;
			success = false;
		}
		else {
			T->set_wrap_s(TW_REPEAT);
			T->set_wrap_t(TW_REPEAT);
		}
		textures.push_back(T);
	}
	return success;
}

/// configure the alpha test that is performed in case alpha values are given in the textures
void textured_material::set_alpha_test(AlphaTestFunc _alpha_test_func, float _alpha_threshold)
{
	alpha_test_func = _alpha_test_func;
	alpha_threshold = _alpha_threshold;
}


/// return the currently set alpha test function
textured_material::AlphaTestFunc textured_material::get_alpha_test_func() const
{
	return alpha_test_func;
}


/// return the currently used alpha threshold used by the comparison alpha test functions
float textured_material::get_alpha_threshold() const
{
	return alpha_threshold;
}

/// return reference to currently set alpha test function
textured_material::AlphaTestFunc& textured_material::ref_alpha_test_func()
{
	return alpha_test_func;
}
/// return reference to currently used alpha threshold used by the comparison alpha test functions
float& textured_material::ref_alpha_threshold()
{
	return alpha_threshold;
}

void destruct_texture(context& ctx, texture*& T)
{
	if (!T)
		return;
	T->destruct(ctx);
	delete T;
	T = 0;
}

/// destruct textures
void textured_material::destruct_textures(context& ctx)
{
	for (size_t ti = 0; ti < textures.size(); ++ti) {
		if (textures[ti]) {
			textures[ti]->destruct(ctx);
			delete textures[ti];
			textures[ti] = 0;
		}
	}
	textures.clear();
}

/// enable by modulating opacities of material with given opacity value
void textured_material::enable_textures(context& ctx)
{
	for (size_t ti = 0; ti < textures.size(); ++ti) {
		if (textures[ti])
			textures[ti]->enable(ctx, ti);
	}
}

/// disable material
void textured_material::disable_textures(context& ctx)
{
	for (size_t ti = 0; ti < textures.size(); ++ti) {
		if (textures[ti])
			textures[ti]->disable(ctx);
	}
}

/// return pointer to ambient texture or 0 if non created
texture* textured_material::get_texture(size_t ti) const
{
	assert(ti < textures.size());
	return textures[ti];
}

	}
}

