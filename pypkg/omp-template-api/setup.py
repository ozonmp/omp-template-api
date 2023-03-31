import setuptools

setuptools.setup(
    name="grpc-omp-template-api",
    version="1.0.0",
    author="rusdevop",
    author_email="rusdevops@gmail.com",
    description="GRPC python client for omp-template-api",
    url="https://github.com/ozonmp/omp-template-api",
    packages=setuptools.find_packages(),
    package_data={"ozonmp.omp_template_api.v1": ["omp_template_api_pb2.pyi"]},
    python_requires='>=3.5',
)