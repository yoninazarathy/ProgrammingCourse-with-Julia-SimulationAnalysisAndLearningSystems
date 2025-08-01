<!DOCTYPE html>
<HTML lang = "en">
<HEAD>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
  {{#:title}}<title>{{:title}}</title>{{/:title}}
  {{{ :header_script }}}

  <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]},
      TeX: { equationNumbers: { autoNumber: "AMS" } }
    });
  </script>

  <script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
  </script>

  {{{ :highlight_stylesheet }}}

  <style type="text/css">
  {{{ :stylesheet }}}
  </style>
  <link rel="icon" type="image/png" href="../img/favicon-32x32.png">
</HEAD>

<BODY>
  <div class ="container">
    <div class = "row">
      <div class = "col-md-12 twelve columns">
        <div class="title">
          {{#:title}}<h1 class="title">{{:title}}</h1>{{/:title}}
          {{#:author}}<h5>{{{:author}}}</h5>{{/:author}}
          {{#:date}}<h5>{{{:date}}}</h5>{{/:date}}
        </div>

          <h1 class="my-3">UQ MATH2504, Programming of Simulation, Analysis, and Learning Systems (Semester 2, 2025)</h1>
          <br>
          <center>
              <a href="https://courses.smp.uq.edu.au/MATH2504/"> Main MATH2504 Page</a>
          </center>
          <br>
          <br>

        {{{ :body }}}

        <HR/>
        <div class="footer">
          <br>
          <center>
              <a href="https://courses.smp.uq.edu.au/MATH2504/"> Main MATH2504 Page</a>
          </center>
          <p>
            Published from <a href="{{{:weave_source}}}">{{{:weave_source}}}</a>
            using <a href="http://github.com/JunoLab/Weave.jl">Weave.jl</a> {{:weave_version}} on {{:weave_date}}.
          </p>
        </div>
      </div>
    </div>
  </div>
</BODY>

</HTML>