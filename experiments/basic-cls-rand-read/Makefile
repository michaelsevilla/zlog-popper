timestamp: visualize.ipynb visualize_final.ipynb $(shell find results.* -name "*.log" -type f)
	docker run -v "`pwd`:/home/jovyan/work" \
		jupyter/scipy-notebook \
		jupyter nbconvert --stdout --execute visualize.ipynb > /dev/null
	touch timestamp
	docker run -v "`pwd`:/home/jovyan/work" \
		jupyter/scipy-notebook \
		jupyter nbconvert --stdout --execute visualize_final.ipynb > /dev/null
	touch timestamp
