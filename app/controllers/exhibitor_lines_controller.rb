class ExhibitorLinesController < ApplicationController

  def index
    @exhibitor_lines = ExhibitorLine.for_show(@current_show.id).ordered
    
    tf = Tempfile.open('exhibitor_lines_report')
    tf.write(make_pdf)
    tf.close
    
    send_file tf.path,
      :filename => 'exhibitor_list_by_line.pdf',
      :type => 'application/pdf',
      :disposition => 'inline',
      :stream => false

    tf.unlink
  end
end
