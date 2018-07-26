#pragma once

#include <cgv/render/drawable.h>
#include <cgv/render/shader_program.h>
#include <cgv/render/view.h>
#include <cgv/media/illum/phong_material.hh>

#include "point_cloud.h"

#include <cgv_gl/point_renderer.h>
#include <cgv_gl/normal_renderer.h>
#include <cgv_gl/box_renderer.h>
#include <cgv_gl/box_wire_renderer.h>

#include "lib_begin.h"


/** drawable for a point cloud that manages a neighbor graph and a normal estimator and supports rendering of point cloud and bounding box. */
class CGV_API gl_point_cloud_drawable_base : public cgv::render::drawable, public point_cloud_types
{
public:
	typedef cgv::media::illum::phong_material::color_type color_type;

protected:
	point_cloud pc;

	std::string data_path;
	std::string file_name;

	cgv::render::point_render_style point_style;
	cgv::render::normal_render_style normal_style;
	cgv::render::surface_render_style box_style;
	cgv::render::line_render_style box_wire_style;

	cgv::render::point_renderer p_renderer;
	cgv::render::normal_renderer n_renderer;
	cgv::render::box_renderer b_renderer;
	cgv::render::box_wire_renderer bw_renderer;

	bool show_points;
	bool show_box;
	bool show_boxes;
	bool show_nmls;
	bool sort_points;
	bool use_component_colors;
	bool use_component_transformations;
	color_type box_color;
	
	std::vector<Clr>* use_these_point_colors;
	std::vector<cgv::type::uint8_type>* use_these_point_color_indices;
	std::vector<RGBA>* use_these_point_palette;
	std::vector<RGBA>* use_these_component_colors;

	// reduction to subset 
	unsigned show_point_step;
	std::size_t show_point_begin, show_point_end;
	unsigned nr_draw_calls;
	cgv::render::view* view_ptr;
	bool ensure_view_pointer();

public:
	gl_point_cloud_drawable_base();

	bool read(const std::string& file_name);
	bool append(const std::string& file_name, bool add_component = true);
	bool write(const std::string& file_name);
	
	void render_boxes(cgv::render::context& ctx, cgv::render::group_renderer& R, cgv::render::group_render_style& RS);
	void draw_box(cgv::render::context& ctx, const Box& box, const color_type& clr);
	void draw_boxes(cgv::render::context& ctx);
	void draw_points(cgv::render::context& ctx);
	void draw_normals(cgv::render::context& ctx);

	bool init(cgv::render::context& ctx);
	void draw(cgv::render::context& ctx);
	void clear(cgv::render::context& ctx);
};

#include <cgv/config/lib_end.h>
