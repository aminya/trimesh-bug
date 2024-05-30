import trimesh


def main():
    """
    Load a obj mesh that has a material and export it back to obj.
    """

    asset_dir = "./trimesh-bug/assets"

    mesh = trimesh.load_mesh(f"{asset_dir}/cube.obj")

    if isinstance(mesh, list):
        raise RuntimeError("Multiple meshes found.")

    # cast Geometry to the more specific Trimesh type
    if not isinstance(mesh, trimesh.Trimesh) and not isinstance(mesh, trimesh.Scene):
        raise RuntimeError(
            "The mesh geometry is not a trimesh.Trimesh or trimesh.Scene."
        )

    obj_content = mesh.export(file_type="obj")
    if not isinstance(obj_content, str):
        raise RuntimeError("The obj_content is not a string.")

    with open(f"{asset_dir}/cube_rexport.obj", "w", encoding="utf-8") as f:
        f.write(obj_content)


if __name__ == "__main__":
    main()
