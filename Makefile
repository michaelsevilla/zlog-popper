all: out/paper.pdf

.PHONY: figures

figures:
	make -C experiments/throughput-sweep/
	make -C experiments/librados-sweep/
	make -C experiments/basic-cls-overhead/

out/paper.pdf: paper.md figures $(shell find vendor -type f)
	docker run \
	  --rm \
	  --workdir="/root" \
	  -v `pwd`/experiments/:/root/experiments \
	  -v `pwd`/vendor/:/root/.pandoc/templates \
	  -v `pwd`/vendor/:/root/texmf/tex/latex \
	  -v `pwd`/paper.md:/root/paper.md \
	  -v `pwd`/out:/root/out \
	  ivotron/pandoc:1.13.2 \
	    --standalone \
	    --highlight-style tango \
	    --output=out/paper.pdf paper.md
		# 2> build.log
	    #--filter pandoc-citeproc
	#chown $(USER): $@

nb:
	docker run -d -p 8888:8888 -v `pwd`:/home/jovyan/work jupyter/scipy-notebook

nbf:
	docker run -p 8888:8888 -v `pwd`:/home/jovyan/work jupyter/scipy-notebook
