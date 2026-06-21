import pathlib as path
import os

target_path = path.Path(".") / "compiled"
root_path = path.Path("..")

source_path = root_path / "src"

def create(create_path: path.Path, content: bytes = None):
    create_path.parent.mkdir(exist_ok=True, parents=True)
    
    if content:
        file = open(create_path, "wb")
        file.write(content)
        file.close()

def compile_directory(directory: path.Path):
    for file in directory.iterdir():
        file_target = (target_path / file.relative_to(source_path)).absolute()
        print(file_target)

        if file.is_dir(): 
            compile_directory(file)
        elif file.suffix == ".lua":
            file_target.parent.mkdir(exist_ok=True, parents=True)

            os.system(f"luajit -b \"{file.absolute()}\" \"{file_target.absolute()}\"")
        else:
            create(file_target, file.read_bytes())

compile_directory(source_path)