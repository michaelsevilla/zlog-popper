output.png: visualize.ipynb $(shell find results.* -name "*.log" -type f)
	docker run -p 8888:8888 -v "`pwd`:/home/jovyan/work" \
		jupyter/scipy-notebook \
		jupyter nbconvert --stdout --execute $< > /dev/null
