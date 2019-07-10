from setuptools import setup, find_packages

setup(
    name='example_app',
    version='0.0.1',
    packages=find_packages(exclude=[ 'docs' ]),
    install_requires=[],
    classifiers=(
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'Programming Language :: Python :: 3.6',
        'Operating System :: Linux',
        'Topic :: Web Apps',
    ),
    author='Sasha Elaine Fox'
)
