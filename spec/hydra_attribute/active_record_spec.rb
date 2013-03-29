require 'spec_helper'

describe HydraAttribute::ActiveRecord do
  describe '.new' do
    let!(:attr1) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'code',    backend_type: 'string',   default_value: nil) }
    let!(:attr2) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'info',    backend_type: 'string',   default_value: '') }
    let!(:attr3) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'total',   backend_type: 'integer',  default_value: 0) }
    let!(:attr4) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'price',   backend_type: 'float',    default_value: 0) }
    let!(:attr5) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'active',  backend_type: 'boolean',  default_value: 0) }
    let!(:attr6) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'started', backend_type: 'datetime', default_value: '2013-01-01') }

    let(:product) { Product.new(attributes) }

    describe 'without any attributes' do
      let(:attributes) { {} }

      it 'should return default values' do
        product.code.should be_nil
        product.info.should == ''
        product.total.should be(0)
        product.price.should == 0.0
        product.active.should be_false
        product.started.should == Time.utc('2013-01-01')
      end
    end

    describe 'with "code", "info" and "price" attributes' do
      let(:attributes) { {code: 'a', info: nil, price: nil} }

      it 'should save these attributes into database' do
        product.code.should == 'a'
        product.info.should be_nil
        product.total.should be(0)
        product.price.should == nil
        product.active.should be_false
        product.started.should == Time.utc('2013-01-01')
      end
    end

    describe 'with all attributes' do
      let(:attributes) { {code: 'a', info: 'b', total: 3, price: 4.3, active: true, started: Time.utc('2013-02-03')} }

      it 'should save all these attributes into database' do
        product.code.should == 'a'
        product.info.should == 'b'
        product.total.should == 3
        product.price.should == 4.3
        product.active.should be_true
        product.started.should == Time.utc('2013-02-03')
      end
    end

    describe 'with all attributes and hydra_set_id' do
      let(:hydra_set_id) { HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'default').id }
      let(:attributes)   { {code: 'a', info: 'b', total: 3, price: 4.3, active: true, started: Time.utc('2013-02-03'), hydra_set_id: hydra_set_id} }

      before do
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set_id, hydra_attribute_id: attr1.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set_id, hydra_attribute_id: attr3.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set_id, hydra_attribute_id: attr5.id)
      end

      it 'should save only attributes from this hydra set' do
        product.code.should == 'a'
        lambda { product.info }.should raise_error HydraAttribute::HydraSet::MissingAttributeInHydraSetError, "Attribute ID #{attr2.id} is missed in Set ID #{hydra_set_id}"
        product.total.should == 3
        lambda { product.price }.should raise_error HydraAttribute::HydraSet::MissingAttributeInHydraSetError, "Attribute ID #{attr4.id} is missed in Set ID #{hydra_set_id}"
        product.active.should be_true
        lambda { product.started }.should raise_error HydraAttribute::HydraSet::MissingAttributeInHydraSetError, "Attribute ID #{attr6.id} is missed in Set ID #{hydra_set_id}"
      end
    end
  end

  describe '.create' do
    let!(:attr1) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'code',    backend_type: 'string',   default_value: nil) }
    let!(:attr2) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'info',    backend_type: 'string',   default_value: '') }
    let!(:attr3) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'total',   backend_type: 'integer',  default_value: 0) }
    let!(:attr4) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'price',   backend_type: 'float',    default_value: 0) }
    let!(:attr5) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'active',  backend_type: 'boolean',  default_value: 0) }
    let!(:attr6) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'started', backend_type: 'datetime', default_value: '2013-01-01') }

    let(:product) { Product.find(Product.create(attributes).id) }

    describe 'without any attributes' do
      let(:attributes) { {} }

      it 'should have default values' do
        product.code.should be_nil
        product.info.should == ''
        product.total.should be(0)
        product.price.should == 0.0
        product.active.should be_false
        product.started.should == Time.utc('2013-01-01')
      end
    end

    describe 'with "code", "info" and "price" attributes' do
      let(:attributes) { {code: 'a', info: nil, price: nil} }

      it 'should save these attributes into database' do
        product.code.should == 'a'
        product.info.should be_nil
        product.total.should be(0)
        product.price.should == nil
        product.active.should be_false
        product.started.should == Time.utc('2013-01-01')
      end
    end

    describe 'with all attributes' do
      let(:attributes) { {code: 'a', info: 'b', total: 3, price: 4.3, active: true, started: Time.utc('2013-02-03')} }

      it 'should save all these attributes into database' do
        product.code.should == 'a'
        product.info.should == 'b'
        product.total.should == 3
        product.price.should == 4.3
        product.active.should be_true
        product.started.should == Time.utc('2013-02-03')
      end
    end

    describe 'with all attributes and hydra_set_id' do
      let(:hydra_set_id) { HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'default').id }
      let(:attributes)   { {code: 'a', info: 'b', total: 3, price: 4.3, active: true, started: Time.utc('2013-02-03'), hydra_set_id: hydra_set_id} }

      before do
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set_id, hydra_attribute_id: attr1.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set_id, hydra_attribute_id: attr3.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: hydra_set_id, hydra_attribute_id: attr5.id)
      end

      let(:value) { ->(entity, attr) { ActiveRecord::Base.connection.select_value("SELECT value FROM hydra_#{attr.backend_type}_#{entity.class.table_name} WHERE entity_id = #{entity.id} AND hydra_attribute_id = #{attr.id}") } }

      it 'should save only attributes from this hydra set' do
        value.(product, attr1).should == 'a'
        value.(product, attr2).should be_nil
        value.(product, attr3).to_i.should == 3
        value.(product, attr4).should be_nil
        ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.should include(value.(product, attr5))
        value.(product, attr6).should be_nil
      end
    end
  end

  describe '.find' do
    before do
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'code', backend_type: 'integer')
    end

    it 'should have hydra attributes' do
      product = Product.create(name: 'one', title: 'wow', code: 42)
      product = Product.find(product.id)
      product.name.should  == 'one'
      product.title.should == 'wow'
      product.code.should  == 42
    end
  end

  describe '.count' do
    before do
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'code', backend_type: 'integer')
      Product.create(name: 'one', title: 'abc', code: 42)
      Product.create(name: 'two', title: 'qwe', code: 52)
    end

    it 'should correct count the number of records' do
      Product.count.should be(2)
    end
  end

  describe '.group' do
    before do
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'code', backend_type: 'integer')
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'total', backend_type: 'integer')

      Product.create(name: 'a', code: 1, title: 'q', total: 5)
      Product.create(name: 'b', code: 2, title: 'w', total: 5)
      Product.create(name: 'b', code: 3, title: 'w')
      Product.create(name: 'c', code: 4, title: 'e')
    end

    describe 'without where condition' do
      it 'should be able to group by hydra and by static attributes' do
        Product.group(:name).count.stringify_keys.should  == {'a'=>1, 'b'=>2, 'c'=>1}
        Product.group(:code).count.stringify_keys.should  == {'1'=>1, '2'=>1, '3'=>1, '4'=>1}
        Product.group(:total).count.stringify_keys.should == {'5'=>2, ''=>2}
        Product.group(:name, :title).count.should         == {%w[a q]=>1, %w[b w]=>2, %w[c e]=>1}
      end
    end

    describe 'with where condition' do
      it 'should be able to group by hydra and by static attributes' do
        Product.where(title: 'w').group(:name).count.stringify_keys.should  == {'b'=>2}
        Product.where(title: 'w').group(:code).count.stringify_keys.should  == {'2'=>1, '3'=>1}
        Product.where(title: 'w').group(:total).count.stringify_keys.should == {'5'=>1, ''=>1}
        Product.where(total: nil).group(:name, :title).count.should         == {%w[b w]=>1, %w[c e]=>1}
      end
    end
  end

  describe '.order' do
    before do
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'state', backend_type: 'integer')
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')

      Product.create(name: 'a', state: 3, title: 'c')
      Product.create(name: 'b', state: 2, title: 'b')
      Product.create(name: 'c', state: 1, title: 'b')
    end

    it 'should order by one field' do
      Product.order(:name).map(&:name).should == %w[a b c]
      Product.order(:state).map(&:name).should == %w[c b a]
    end

    it 'should order by two fields' do
      Product.order(:title, :state).map(&:name).should == %w[c b a]
      Product.order(:title, :name).map(&:name).should == %w[b c a]
    end

    it 'should order by field with with filter' do
      Product.where(name: %w[a b]).order(:title).map(&:name).should == %w[b a]
      Product.where(title: 'b').order(:state).map(&:name).should == %w[c b]
    end
  end

  describe '.reverse_order' do
    before do
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'state', backend_type: 'integer')
      HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'title', backend_type: 'string')

      Product.create(name: 'a', state: 3, title: 'c')
      Product.create(name: 'b', state: 2, title: 'b')
      Product.create(name: 'c', state: 1, title: 'b')
    end

    it 'should order by one field and reorder list' do
      Product.order(:name).reverse_order.map(&:name).should == %w[c b a]
      Product.order(:state).reverse_order.map(&:name).should == %w[a b c]
    end

    it 'should order by two fields and reorder list' do
      Product.order(:title, :state).reverse_order.map(&:name).should == %w[a b c]
      Product.order(:title, :name).reverse_order.map(&:name).should == %w[a c b]
    end

    it 'should order by field with with filter and reorder list' do
      Product.where(name: %w[a b]).order(:title).reverse_order.map(&:name).should == %w[a b]
      Product.where(title: 'b').order(:state).reverse_order.map(&:name).should == %w[b c]
    end
  end

  describe '.where' do
    let!(:attr1) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'info',    backend_type: 'string')   }
    let!(:attr2) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'total',   backend_type: 'integer')  }
    let!(:attr3) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'price',   backend_type: 'float')    }
    let!(:attr4) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'active',  backend_type: 'boolean')  }
    let!(:attr5) { HydraAttribute::HydraAttribute.create(entity_type: 'Product', name: 'started', backend_type: 'datetime') }

    describe 'without attribute sets' do
      before do
        Product.create(name: 'a', info: 'a', total: 2,   price: 3.5, active: true,  started: '2013-01-01')
        Product.create(name: 'b', info: 'a', total: 3,   price: nil, active: false, started: '2013-01-02')
        Product.create(name: 'c' ,info: 'b', total: nil, price: nil, active: nil,   started: '2013-01-01')
        Product.create(name: 'd', info: nil, total: 3,   price: 3.5, active: true,  started: nil)
      end

      it 'should filter by one attribute' do
        Product.where(info: 'a').map(&:name).should =~ %w[a b]
        Product.where(info: nil).map(&:name).should =~ %w[d]
        Product.where(total: 3).map(&:name).should =~ %w[b d]
        Product.where(total: nil).map(&:name).should =~ %w[c]
        Product.where(price: 3.5).map(&:name).should =~ %w[a d]
        Product.where(price: nil).map(&:name).should =~ %w[b c]
        Product.where(active: true).map(&:name).should =~ %w[a d]
        Product.where(active: false).map(&:name).should =~ %w[b]
        Product.where(active: nil).map(&:name).should =~ %w[c]
        Product.where(started: Time.utc('2013-01-01')).map(&:name).should =~ %w[a c]
        Product.where(started: nil).map(&:name).should =~ %w[d]
      end

      it 'should filter by several attributes' do
        Product.where(info: %w[a b], name: %w[b c]).map(&:name).should =~ %w[b c]
        Product.where(info: %w[a b], price: nil).map(&:name).should =~ %w[b c]
        Product.where(active: nil, started: Time.utc('2013-01-01')).map(&:name).should =~ %w[c]
        Product.where(price: 3.5,  started: nil).map(&:name).should =~ %w[d]
        Product.where(total: 3,  active: true).map(&:name).should =~ %w[d]
      end
    end

    describe 'with attribute sets' do
      before do
        set1 = HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'default')
        set2 = HydraAttribute::HydraSet.create(entity_type: 'Product', name: 'second')
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: set1.id, hydra_attribute_id: attr1.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: set2.id, hydra_attribute_id: attr2.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: set1.id, hydra_attribute_id: attr3.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: set2.id, hydra_attribute_id: attr4.id)
        HydraAttribute::HydraAttributeSet.create(hydra_set_id: set1.id, hydra_attribute_id: attr5.id)

        p1 = Product.create(name: 'a', info: 'a', total: 2,   price: 3.5, active: true,  started: '2013-01-01')
        p2 = Product.create(name: 'b', info: 'a', total: 3,   price: nil, active: false, started: '2013-01-02')
        p3 = Product.create(name: 'c' ,info: 'b', total: nil, price: nil, active: nil,   started: '2013-01-01')
        p4 = Product.create(name: 'd', info: nil, total: 3,   price: 3.5, active: true,  started: nil)
        p5 = Product.create(name: 'e', info: 'c', total: 7,   price: 4.2, active: false, started: '2013-01-03')
        p6 = Product.create(name: 'f', info: 'c', total: 5,   price: 4.2, active: false, started: '2013-01-03')
        p7 = Product.create(name: 'g', info: nil, total: 7,   price: 5.5, active: nil,   started: nil)
        p1.hydra_set_id = nil
        p2.hydra_set_id = set1.id
        p3.hydra_set_id = set2.id
        p4.hydra_set_id = set2.id
        p5.hydra_set_id = set1.id
        p6.hydra_set_id = set1.id
        p7.hydra_set_id = nil
        [p1, p2, p3, p4, p5, p6, p7].each(&:save)
      end

      it 'should filter by one attribute' do
        Product.where(info: 'a').map(&:name).should =~ %w[a b]
        Product.where(info: nil).map(&:name).should =~ %w[g]
        Product.where(total: 3).map(&:name).should =~ %w[d]
        Product.where(total: nil).map(&:name).should =~ %w[c]
        Product.where(price: 3.5).map(&:name).should =~ %w[a]
        Product.where(price: nil).map(&:name).should =~ %w[b]
        Product.where(active: true).map(&:name).should =~ %w[a d]
        Product.where(active: false).map(&:name).should == []
        Product.where(active: nil).map(&:name).should =~ %w[c g]
        Product.where(started: Time.utc('2013-01-01')).map(&:name).should =~ %w[a]
        Product.where(started: nil).map(&:name).should =~ %w[g]
      end

      it 'should filter by several attributes' do
        Product.where(info: ['a', 'b', 'c', nil], name: %w[a b c d e f g]).map(&:name).should =~ %w[a b e f g]
        Product.where(info: %w[a b], price: nil).map(&:name).should =~ %w[b]
        Product.where(active: nil, started: Time.utc('2013-01-01')).map(&:name).should == []
        Product.where(price: 3.5,  started: Time.utc('2013-01-01')).map(&:name).should =~ %w[a]
        Product.where(total: [3, 5, 7],  active: [true, false]).map(&:name).should =~ %w[d]
      end
    end
  end
end